tableextension 50103 "Item Charge Extension" extends "Item Charge"
{
    fields
    {
        field(50100; "Unit Price"; decimal)
        {
            Caption = 'Unit Price';
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