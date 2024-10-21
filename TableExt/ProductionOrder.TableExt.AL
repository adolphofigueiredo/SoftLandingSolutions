tableextension 50101 "Production Order Ext" extends "Production Order"
{
    fields
    {
        field(50100; "Sales Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
    }
}