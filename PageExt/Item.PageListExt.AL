pageextension 50103 "Item List Extension" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("Item Type"; Rec."Item Type")
            {
                Caption = 'Item Type';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}