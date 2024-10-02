table 50150 "SLS Commesse Base Header"
{
    Caption = 'Commesse Base Header';

    fields
    {

        field(1; "No. Pacchetto Base"; Code[20])
        {
            //Creare un campo combo box ed obbligatòrio per scegliere l'articolo basato sulla categoria pachetto base 999990
            TableRelation = Item where("Item Category Code" = filter(999990));
            NotBlank = true;
        }
        field(2; "Pacchetto Base"; Text[100])
        {
            //Prendere il codice No. Pacchetto Base e cercare la descrizione.
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("No. Pacchetto Base")));
        }
    }

    keys
    {
        key(Key1; "No. Pacchetto Base")
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