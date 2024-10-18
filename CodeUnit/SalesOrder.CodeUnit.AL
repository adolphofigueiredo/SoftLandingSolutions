codeunit 50100 "Prod. Order Subscriver"
{
    SingleInstance = true;
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", 'OnAfterCreateProdOrder', '', false, false)]
    internal procedure OnAfterCreateProdOrder(var ProdOrder: Record "Production Order"; var SalesLine: Record "Sales Line")
    var
        salesOreder: Page "Sales Order";
    begin
        Rec_prodOrder := ProdOrder;
        ProdOrder."Sales Order No." := SalesLine."Document No.";
        ProdOrder.Modify();
    end;

    internal procedure GetCreatedProductionOrder(): Record "Production Order"
    begin
        exit(Rec_prodOrder);
    end;

    var
        Rec_prodOrder: Record "Production Order";
}
