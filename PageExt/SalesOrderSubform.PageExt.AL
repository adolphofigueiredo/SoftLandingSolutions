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
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("&Line")
        {
            action(CommentToArticle)
            {
                AccessByPermission = TableData "Item" = R;
                ApplicationArea = all;
                Caption = 'Customiza Articolo';
                Scope = Repeater;
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
                    Item.FindSet();
                    if item."Item Category Code" <> '' then begin
                        ItemListPage.SetTableView(Item);
                        ItemListPage.LookupMode(true);

                        if ItemListPage.RunModal() = ACTION::LookupOK then begin
                            ItemListPage.GetRecord(Item);

                            SalesLineInsert := GetCurretSalesLine();
                            SalesLineInsert."Line No." := SalesLineInsert."Line No." - 10000;

                            DeleteSalesLine := GetCurretSalesLine();
                            DeleteSalesLine.Delete();

                            SalesLineInsert.AddItem(SalesLineInsert, Item."No.");
                            SalesLineInsert."Qty. to Ship" := 0;
                            SalesLineInsert."Item Type" := Item."Item Type";
                            SalesLineInsert.Modify();
                            setAllQuantity();
                        end;
                    end else begin
                        Message('L''''articolo non ha un gruppo categoria');
                    end;
                end;
            }
        }
        addafter(SelectMultiItems)
        {
            action(SetQuantity)
            {
                ApplicationArea = all;
                Caption = 'Inserisci quantita a le customizazioni';
                Image = AddAction;
                trigger OnAction()
                var
                begin
                    setAllQuantity();
                end;
            }
        }
    }
    internal procedure setAllQuantity()
    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        itemQuantity: Decimal;
        isTypeItem: Boolean;
        isTypeItemBase: Boolean;
        isTypeItemCust: Boolean;
        isTypeItemAddOn: Boolean;
        isTypeCharge: Boolean;
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindSet() then begin
            repeat begin
                isTypeItem := SalesLine.Type = SalesLine.Type::Item;
                isTypeItemBase := SalesLine."Item Type" = SalesLine."Item Type"::"Base Item";
                isTypeItemCust := SalesLine."Item Type" = SalesLine."Item Type"::"Item Customization";
                isTypeItemAddOn := SalesLine."Item Type" = SalesLine."Item Type"::"Add-on";
                isTypeCharge := SalesLine.Type = SalesLine.Type::"Charge (Item)";
                if (isTypeItem) and (isTypeItemBase) then begin
                    itemQuantity := SalesLine.Quantity;
                end;
                if (isTypeItem) and ((isTypeItemAddOn) or (isTypeItemCust)) then begin
                    SalesLine.Quantity := itemQuantity;
                    SalesLine.Validate(Quantity, itemQuantity);
                    SalesLine.Modify();
                end;
                if (isTypeCharge) and (isTypeItemCust) then begin
                    SalesLine.Quantity := itemQuantity;
                    SalesLine.Validate(Quantity, itemQuantity);
                    SalesLine."Qty. to Ship" := 0;
                    SalesLine.Modify();
                end;
            end until SalesLine.Next() = 0;
        end;
    end;

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
        itemRecord: Record Item;
        DbProduzioneLine: Record "Production BOM Line";
        addLineNo: Integer;
        ChargeItem: Record "Item Charge";
    begin
        addLineNo := Rec."Line No.";
        if (Rec.Type = "Sales Line Type"::Item) and (Rec."Item Type" = "Article Type"::"Base Item") then begin
            DbProduzioneLine.SetRange("Production BOM No.", Rec."No.");
            repeat begin
                if DbProduzioneLine.Description <> '' then begin
                    addLineNo += 10000;
                    SalesLines."Document Type" := Rec."Document Type";
                    SalesLines."Document No." := rec."Document No.";
                    SalesLines."Line No." := addLineNo;
                    SalesLines.Description := '    ' + DbProduzioneLine.Description;
                    SalesLines."No." := DbProduzioneLine."No.";
                    if itemRecord.Get(SalesLines."No.") then begin
                        SalesLines."Item Type" := itemRecord."Item Type";
                    end;
                    SalesLines.Insert();
                end;
            end until DbProduzioneLine.Next() = 0;
            itemRecord.Get(Rec."No.");
            if ChargeItem.Get(itemRecord."Charge Item") then begin
                addLineNo += 10000;
                SalesLines."Document Type" := Rec."Document Type";
                SalesLines."Document No." := rec."Document No.";
                SalesLines."Line No." := addLineNo;
                SalesLines.Description := ChargeItem.Description;
                SalesLines."No." := ChargeItem."No.";
                SalesLines."Unit Price" := ChargeItem."Unit Price";
                SalesLines."Type" := "Sales Line Type"::"Charge (Item)";
                SalesLines.Insert();
            end;
        end;
    end;
}