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
                    ProdOrderFromSale: Codeunit "Create Prod. Order from Sale";
                    SalesLineRecord: Record "Sales Line";
                begin
                    if (rec.Status = "Sales Document Status"::Released) then begin
                        SalesLineRecord.SetRange("Document Type", SalesLineRecord."Document Type"::Order);
                        SalesLineRecord.SetRange("Document No.", Rec."No.");
                        if SalesLineRecord.FindSet() then begin
                            repeat begin
                                ProdOrderFromSale.CreateProductionOrder(SalesLineRecord, "Create Production Order Status"::Planned, "Create Production Order Type"::ItemOrder);
                            end until SalesLineRecord.Next = 0;
                        end else begin
                            Message('Non ci Sono Articoli da mettere in produzione');
                        end;
                    end else begin
                        Message('Lo stato del ordine di vendita non e %1', "Sales Document Status"::Released);
                    end;
                end;
            }
        }
    }
}