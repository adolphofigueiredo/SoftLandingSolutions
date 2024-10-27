tableextension 50102 "Item Table Extension" extends Item
{
    fields
    {
        field(50100; "Item Type"; Enum "Article Type")
        {
            Caption = 'Item Type';
        }

        field(50101; "Charge Item"; Code[20])
        {
            Caption = 'Charge Item';
            TableRelation = "Item Charge";
        }
    }
}