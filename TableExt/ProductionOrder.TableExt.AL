tableextension 50101 "Production Order Ext" extends "Production Order"
{
    fields
    {
        field(50100; "Sales Order No."; Code[20])
        {
            Editable = false; //no editabile 
            TableRelation = "Sales Header"."No.";
        }
        field(50101; "Prod. cycle amount"; Integer)
        {
            Editable = False; //no editabile 
            Caption = 'Importo del ciclo di produzione'; // caption in italiano 
            FieldClass = FlowField; // flowfield
            CalcFormula = count("Item Journal Line" where("Document No." = field("No."), "Item No." = field("Source No."), "Output Quantity" = const(0)));
        }
        field(50102; "Prod. cycles number 2"; Integer)
        {
            Editable = False; //no editabile 
            Caption = 'Nr. cicli di produzione'; // caption in italiano 
            FieldClass = FlowField; // flowfield
            CalcFormula = count("Prod. Order Routing Line" where("Routing Reference No." = const(10000), Status = field(Status), "Prod. Order No." = field("No.")));
        }
    }
}