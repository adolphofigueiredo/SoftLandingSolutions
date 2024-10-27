pageextension 50102 "Item Page Extension" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Item Type"; Rec."Item Type")
            {
                Caption = 'Item Type';
                ApplicationArea = all;
                ShowMandatory = true;
                BlankZero = true;
            }
            field("Charge Item"; Rec."Charge Item")
            {
                Caption = 'Charge Item';
                ApplicationArea = all;
            }
        }
    }
}