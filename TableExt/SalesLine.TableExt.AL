tableextension 50100 "Sales Line Extantion" extends "Sales Line"
{
    fields
    {
        field(50100; "Item Type"; Enum "Article Type")
        {
            Caption = 'Item Type';
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