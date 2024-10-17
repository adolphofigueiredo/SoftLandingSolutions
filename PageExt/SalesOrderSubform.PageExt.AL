pageextension 50101 "Sales Order Subform Extension" extends "Sales Order Subform"
{

    // da implementare in futuro o anche subito
    // fare in modo che la locatio code sia sempre vuota (SalesOrder.PageExt.al)

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
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindSet() then begin
            repeat begin
                isTypeItem := SalesLine.Type = SalesLine.Type::Item;
                isTypeItemBase := SalesLine."Item Type" = SalesLine."Item Type"::"Base Item";
                isTypeItemCust := SalesLine."Item Type" = SalesLine."Item Type"::"Item Customization";
                isTypeItemAddOn := SalesLine."Item Type" = SalesLine."Item Type"::"Add-on";
                if (isTypeItem) and (isTypeItemBase) then begin
                    itemQuantity := SalesLine.Quantity;
                end;
                if (isTypeItem) and ((isTypeItemAddOn) or (isTypeItemCust)) then begin
                    SalesLine.Quantity := itemQuantity;
                    SalesLine.Validate(Quantity, itemQuantity);
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
        DbProduzioneLine: Record "Production BOM Line";
        addLineNo: Integer;
    begin
        addLineNo := Rec."Line No.";
        // controllo che fa eseguire il codice qui sotto solo se e di "Item Type"::"Base Item"
        DbProduzioneLine.SetRange("Production BOM No.", Rec."No.");
        repeat begin
            if DbProduzioneLine.Description <> '' then begin
                addLineNo += 10000;
                SalesLines."Document Type" := Rec."Document Type";
                SalesLines."Document No." := rec."Document No.";
                SalesLines."Line No." := addLineNo;
                SalesLines.Description := '    ' + DbProduzioneLine.Description;
                SalesLines."No." := DbProduzioneLine."No.";
                SalesLines.Insert();
            end;
        end until DbProduzioneLine.Next() = 0;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        SalesLines: Record "Sales Line";
        LineNo: Integer;
    begin
        LineNo := Rec."Line No.";
        repeat begin
            LineNo += 10000;
            SalesLines."Document Type" := Rec."Document Type";
            SalesLines."Document No." := Rec."Document No.";
            SalesLines."Line No." := LineNo;
            SalesLines.Delete();
        end until SalesLines.Next() = 0;
        // devi fare in modo che l'utente se cancella un record di tipo SalesLine."Item Type"::"Base Item"
        // allora deve cancellare tutte le rige nella sales line fin quando non inconta un altra riga di tipo SalesLine."Item Type"::"Base Item"
        // e se invece l'utente cancella una lina di tipo SalesLine."Item Type"::"Add-On" gli cancella solo quella riga
        // e se cerca di cancellare una riga di tipo SalesLine."Item Type"::"Item Customization" deve lancare ( trow error ) un errore e mostarlo a schermo (try chatch)
    end;
}