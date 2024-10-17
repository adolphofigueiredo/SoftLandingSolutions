pageextension 50100 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
    }
    actions
    {
        addlast(processing)
        {
            action(creaOrdineProduzione)
            {
                Caption = 'Crea Ordine Di Produzione';
                ApplicationArea = all;
                Image = Create;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                begin
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then begin
                        repeat begin
                            if SalesLine.Type <> SalesLine.Type::" " then begin
                                if IsItemArticleType(SalesLine, SalesLine."Item Type"::"Base Item") then begin
                                    if not (isOrderAlreadyCreated(SalesLine."Document No.")) then begin
                                        CreateProductionOrder(SalesLine);
                                    end;
                                end;
                                if IsItemArticleType(SalesLine, SalesLine."Item Type"::"Item Customization") then begin
                                    if isOrderAlreadyCreated(SalesLine."Document No.") then begin
                                        ModifyProductionComponent(SalesLine);
                                    end;
                                end;
                                if IsItemArticleType(SalesLine, SalesLine."Item Type"::"Add-on") then begin
                                    if isOrderAlreadyCreated(SalesLine."Document No.") then begin
                                        // aggiungo l`item nella table 5407
                                    end else begin
                                        // lancio un errore grave
                                    end;
                                end;
                            end;
                        end until SalesLine.Next = 0;
                    end else begin
                        Message('Non ci Sono Articoli da mettere in produzione');
                    end;
                end;
            }
        }
    }

    internal procedure ModifyProductionComponent(SalesLine: Record "Sales Line")
    var
        ProductionOrder: Record "Production Order";
        ProductionComponet: Record "Prod. Order Component";
    begin
        ProductionOrder.SetRange("Sales Order No.", '');
        ProductionOrder.FindSet();
        ProductionComponet.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProductionComponet.SetRange("Item No.", SalesLine."No.");
        ProductionComponet.FindSet();
        ProductionComponet."Item No." := SalesLine."No.";
        ProductionComponet.Description := SalesLine.Description;
        ProductionComponet.Modify();
    end;

    internal procedure InsertProductionComponent(SalesLine: Record "Sales Line")
    var
        ProductionOrder: Record "Production Order";
        ProductionComponet: Record "Prod. Order Component";
        CopyProductionComponet: Record "Prod. Order Component";
    begin
        ProductionOrder.SetRange("Sales Order No.", '');
        ProductionOrder.FindSet();
        ProductionComponet.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProductionComponet.FindLast();
        CopyProductionComponet := ProductionComponet;
        CopyProductionComponet."Line No." += 10000;
        CopyProductionComponet."Item No." := SalesLine."No.";
        CopyProductionComponet.Description := SalesLine.Description;
        CopyProductionComponet.Insert();
    end;

    internal procedure CreateProductionOrder(var SalesLineRecord: Record "Sales Line")
    var
        CodeunitPorductionOrder: Codeunit "Create Prod. Order from Sale";
        ProdOrder: Record "Production Order";
    begin
        CodeunitPorductionOrder.CreateProductionOrder(SalesLineRecord, "Create Production Order Status"::Planned, "Create Production Order Type"::ItemOrder);
        // ma chi ha sviluppato la sand-box microsoft?? non ce una variabile di ritorno che ti dice se ha creato si o no la produzione...
    end;

    internal procedure IsItemArticleType(var SalesLineRecor: Record "Sales Line"; Type: Enum "Article Type"): Boolean
    var
        isType: Boolean;
    begin
        isType := (SalesLineRecor.Type = SalesLineRecor.Type::Item) and (SalesLineRecor."Item Type" = type);
        exit(isType)
    end;

    local procedure isOrderAlreadyCreated(var "SalesLineDocumentNo.": Code[20]): Boolean
    var
        isAlreadyCreated: Boolean;
        ProdOrder: Record "Production Order";
    begin
        ProdOrder.SetRange(ProdOrder."Sales Order No.", "SalesLineDocumentNo.");
        if ProdOrder.FindSet() then begin
            isAlreadyCreated := true;
        end;
        isAlreadyCreated := false;
        exit(isAlreadyCreated)
    end;
}