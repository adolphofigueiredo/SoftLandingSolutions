pageextension 50102 "Item Page Extension" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Item Type"; Rec."Item Type")
            {
                Caption = 'Item Type';
                ShowMandatory = true;
                BlankZero = true;
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