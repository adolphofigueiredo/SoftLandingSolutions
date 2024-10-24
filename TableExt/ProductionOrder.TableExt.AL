tableextension 50101 "Production Order Ext" extends "Production Order"
{
    fields
    {
        field(50100; "Sales Order No."; Code[20])
        {
            Editable = false; //no editabile 
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50101; "Prod. cycle amount"; Integer)
        {
            Editable = False; //no editabile 
            Caption = 'Importo del ciclo di produzione'; // caption in italiano 
            FieldClass = FlowField; // flowfield
            CalcFormula = count("Item Journal Line" where("Document No." = field("No."), "Item No." = field("Source No."), "Output Quantity" = const(0)));
        }
        field(50102; "Prod. cycles number"; Integer)
        {
            Editable = False; //no editabile 
            Caption = 'Nr. cicli di produzione'; // caption in italiano 
            FieldClass = FlowField; // flowfield
            CalcFormula = count("Prod. Order Routing Line" where("Routing Reference No." = const(10000), Status = field(Status), "Prod. Order No." = field("No.")));
        }
        field(50103; "Prod. cycle line"; Text[50])
        {
            Editable = false; // non editabile
            Caption = 'Linea ciclo di produzione'; // etichetta in italiano

            trigger OnLookup()
            begin
                // Mostra il testo formattato '%1 to %2'
                "Prod. cycle line" := StrSubstNo('%1 to %2', "Prod. cycle amount", "Prod. cycles number");
            end;
        }

    }
}