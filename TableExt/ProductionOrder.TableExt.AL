tableextension 50101 "Production Order Ext" extends "Production Order"
{
    fields
    {
        field(50100; "Sales Order No."; Code[20])
        {
            Editable = false; //no editabile 
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50101; "Prod. cycles number"; Integer)
        {
            Editable = False; //no editabile 
            Caption = 'Nr. cicli di produzione'; // caption in italiano 
            FieldClass = FlowField; // flowfield
            CalcFormula = count("Prod. Order Routing Line" where("Routing Reference No." = const(10000), Status = field(Status), "Prod. Order No." = field("No.")));
        }
        field(50102; "Prod. cycle line"; Text[50])
        {
            Editable = false; // non editabile
            Caption = 'Linea ciclo di produzione'; // etichetta in italiano
        }
    }
}