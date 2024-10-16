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
                    SalesLineRecord: Record "Sales Line";
                begin
                    SalesLineRecord.SetRange("Document Type", SalesLineRecord."Document Type"::Order);
                    SalesLineRecord.SetRange("Document No.", Rec."No.");
                    if SalesLineRecord.FindSet() then begin
                        repeat begin
                            if SalesLineRecord."Item Type"= SalesLineRecord."Item Type"::"Base Item"  then begin

                            end;
                        end until SalesLineRecord.Next = 0;
                    end else begin
                        Message('Non ci Sono Articoli da mettere in produzione');
                    end;
                end;
            }
        }
    }
    internal procedure CreateProductionOrder(var SalesLineRecord: Record "Sales Line")
    var
        CodeunitPorductionOrder: Codeunit "Create Prod. Order from Sale";
        ProdOrder: Record "Production Order";
    begin
        CodeunitPorductionOrder.CreateProductionOrder(SalesLineRecord, "Create Production Order Status"::Planned, "Create Production Order Type"::ItemOrder);
        ProdOrder.SetRange(ProdOrder."Sales Order No.",SalesLineRecord."Document No.");
        
        if BooleanExpression then begin
            
        end;
            ProdOrder.Reset();
            ProdOrder.SetRange(ProdOrder."Sales Order No.", '');
            if ProdOrder.FindSet() then begin
                ProdOrder."Sales Order No." := SalesLineRecord."Document No.";
                ProdOrder.Modify()
            end;
    end;

}