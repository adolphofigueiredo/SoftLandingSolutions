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
                                        InsertProductionComponent(SalesLine);
                                    end;
                                end;
                            end;
                        end until SalesLine.Next = 0;
                    end else begin
                        Message('Non ci sono articoli da mettere in produzione.');
                    end;
                end;
            }
        }
    }
    internal procedure ModifyProductionComponent(SalesLine: Record "Sales Line") //fizare il modifica perhce non posso cercare il setcon item no stessa roba per l'insert
    var
        ProductionOrder: Record "Production Order";
        ProductionComponet: Record "Prod. Order Component";
        ProdOrderSubscriver: Codeunit "Prod. Order Subscriver";
        ProdItem: Record Item;
        SalesItem: Record Item;
    begin
        SalesItem.Get(SalesLine."No.");
        ProductionOrder := ProdOrderSubscriver.GetCreatedProductionOrder();
        ProductionComponet.SetRange("Prod. Order No.", ProductionOrder."No.");
        if ProductionComponet.FindSet() then begin
            repeat begin
                prodItem.Get(ProductionComponet."Item No.");
                if prodItem."Item Category Code" = SalesItem."Item Category Code" then begin
                    ProductionComponet."Item No." := SalesLine."No.";
                    ProductionComponet.Description := SalesLine.Description.TrimStart();
                    ProductionComponet.Modify();
                end;
            end until ProductionComponet.Next() = 0;
        end;
    end;

    internal procedure InsertProductionComponent(SalesLine: Record "Sales Line")
    var
        ProductionOrder: Record "Production Order";
        ProductionComponet: Record "Prod. Order Component";
        CopyProductionComponet: Record "Prod. Order Component";
        ProdOrderSubscriver: Codeunit "Prod. Order Subscriver";
    begin
        ProductionOrder := ProdOrderSubscriver.GetCreatedProductionOrder();
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
    begin
        CodeunitPorductionOrder.CreateProductionOrder(SalesLineRecord, "Create Production Order Status"::Planned, "Create Production Order Type"::ItemOrder);
    end;

    internal procedure IsItemArticleType(var SalesLineRecor: Record "Sales Line"; Type: Enum "Article Type"): Boolean
    var
        isType: Boolean;
    begin
        isType := false;
        isType := (SalesLineRecor.Type = SalesLineRecor.Type::Item) and (SalesLineRecor."Item Type" = type);
        exit(isType)
    end;

    local procedure isOrderAlreadyCreated(var "SalesLineDocumentNo.": Code[20]): Boolean
    var
        isAlreadyCreated: Boolean;
        ProdOrder: Record "Production Order";
        CreatedProdOrd: Record "Production Order";
        ProdOrderSubscriver: Codeunit "Prod. Order Subscriver";

    begin
        isAlreadyCreated := false;
        ProdOrder.SetRange("Sales Order No.", "SalesLineDocumentNo.");
        CreatedProdOrd := ProdOrderSubscriver.GetCreatedProductionOrder();
        if ProdOrder.FindSet() then begin
            repeat begin
                if ProdOrder."No." = CreatedProdOrd."No." then begin
                    isAlreadyCreated := true;
                end;
            end until ProdOrder.Next() = 0;
        end;
        exit(isAlreadyCreated)
    end;
}