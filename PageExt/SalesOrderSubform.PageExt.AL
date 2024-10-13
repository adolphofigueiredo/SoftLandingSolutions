pageextension 50101 "Sales Order Subform Extension" extends "Sales Order Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Item Type"; Rec."Item Type")
            {
                Visible = true;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter(SelectMultiItems)
        {
            action(CommentToArticle)
            {
                AccessByPermission = TableData "Item" = R;
                ApplicationArea = all;
                Caption = 'Customiza Articolo';
                Image = Edit;
                trigger OnAction()
                var
                    Item: Record Item;
                    SalesLineInsert: Record "Sales Line";
                    DeleteSalesLine: Record "Sales Line";
                    SalesLineForQuantity: Record "Sales Line";
                    ItemListPage: Page "Item List";
                begin
                    Item.SetRange("Item Category Code", GetItemCategoryCode());
                    ItemListPage.SetTableView(Item);
                    ItemListPage.LookupMode(true);

                    if ItemListPage.RunModal() = ACTION::LookupOK then begin
                        ItemListPage.GetRecord(Item);

                        SalesLineInsert := GetCurretSalesLine();
                        SalesLineInsert."Line No." := SalesLineInsert."Line No." - 10000;

                        DeleteSalesLine := GetCurretSalesLine();
                        DeleteSalesLine.Delete();

                        SalesLineInsert.AddItem(SalesLineInsert, Item."No.");
                        SalesLineInsert."Item Type" := SalesLineInsert."Item Type"::"Item Customization";
                        SalesLineInsert.Modify()
                    end;
                end;
            }
        }
    }
    internal procedure GetCurretSalesLine(): Record "Sales Line"
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Item Type" = Rec."Item Type"::"Item Customization" then begin
            SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetRange("Document No.", Rec."Document No.");
            SalesLine.SetRange("Line No.", Rec."Line No.");
            SalesLine.FindSet();
            exit(SalesLine)
        end;
    end;

    internal procedure GetItemQuantity(currentRecord: Record "Sales Line"): Decimal
    var
        SalesLine: Record "Sales Line";
        ItemQuantity: Decimal;
    begin
        SalesLine.SetRange("Document Type", currentRecord."Document Type"::Order);
        SalesLine.SetRange("Document No.", currentRecord."Document No.");
        SalesLine.SetRange("Line No.", 0, currentRecord."Line No.");
        SalesLine.SetAscending("Line No.", false);
        if SalesLine.FindSet() then begin
            repeat begin
                if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."Item Type" = SalesLine."Item Type"::Item) then begin
                    ItemQuantity := SalesLine.Quantity;
                    break
                end;
            end until SalesLine.Next() = 0;
        end;
        exit(ItemQuantity)
    end;

    internal procedure GetItemCategoryCode(): Code[20]
    var
        item: Record Item;
        SalesLine: Record "Sales Line";
        DescriptionText: Text;
    begin
        SalesLine := GetCurretSalesLine();
        DescriptionText := SalesLine.Description.TrimStart();
        item.SetRange(Description, DescriptionText);
        item.FindSet();
        exit(item."Item Category Code");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesLines: Record "Sales Line";
        DbProduzioneLine: Record "Production BOM Line";
        addLineNo: Integer;
    begin
        addLineNo := Rec."Line No.";
        DbProduzioneLine.SetRange("Production BOM No.", Rec."No.");
        repeat begin
            if DbProduzioneLine.Description <> '' then begin
                addLineNo += 10000;
                SalesLines."Document Type" := Rec."Document Type";
                SalesLines."Document No." := rec."Document No.";
                SalesLines."Line No." := addLineNo;
                SalesLines.Description := '    ' + DbProduzioneLine.Description;
                SalesLines."Item Type" := SalesLines."Item Type"::"Item Customization";
                SalesLines.Insert();
            end;
        end until DbProduzioneLine.Next() = 0;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        myInt: Integer;
    begin

    end;
}