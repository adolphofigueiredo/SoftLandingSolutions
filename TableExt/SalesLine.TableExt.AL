tableextension 50100 "Sales Line Extension" extends "Sales Line"
{
    fields
    {
        field(50100; "Item Type"; Enum "Article Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Item Type" where("No." = field("No.")));

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}