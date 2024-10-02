table 50151 "SLS Commesse Base Lines"
{
    Caption = 'Commesse Base Lines';

    fields
    {

        field(1; "No. Pacchetto Base"; Code[20])
        {
            //Creare un campo combo box per scegliere l'articolo basato sulla categoria pachetto base 999990
            TableRelation = "SLS Commesse Base Header";
            NotBlank = true;
        }
        field(2; "Pacchetto Base"; Text[100])
        {
            //Prendere il codice field1 e cercare la descrizione.
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("No. Pacchetto Base")));
        }

        field(3; "No. Componente"; Code[20])
        {
            //Creare un campo combo box per scegliere l'articolo
            TableRelation = Item where("Item Category Code" = filter(>= 999991 & <= 999999));
            NotBlank = true;
        }
        field(4; "Componente"; Text[100])
        {
            //Prendere il codice field3 e cercare la descrizione.
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("No. Componente")));
        }

        field(5; "Quantità Componente"; Decimal)
        {
            //L'utente deve inserire la quantità che deve essere usata in questo pacchetto.
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; "No. Pacchetto Base", "No. Componente")
        {
            Clustered = true;
        }

    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}