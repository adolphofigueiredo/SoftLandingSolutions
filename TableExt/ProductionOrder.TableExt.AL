tableextension 50101 "Production Order Ext" extends "Production Order"
{
    fields
    {
        field(50100; "Sales Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50101; "Prod. cycles number"; Integer)
        {
            Editable = False;
            Caption = 'Nr. tot cicli di produzione';
            FieldClass = FlowField;
            CalcFormula = count("Prod. Order Routing Line" where("Routing Reference No." = const(10000), Status = field(Status), "Prod. Order No." = field("No.")));
        }
        field(50102; "Prod. cycle status"; Text[50])
        {
            Editable = false;
            Caption = 'Status ciclo di produzione';
        }
    }
}