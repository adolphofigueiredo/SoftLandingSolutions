tableextension 50102 "Item Table Extension" extends Item
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