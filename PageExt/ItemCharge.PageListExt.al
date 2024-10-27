pageextension 50108 "Item Charge Extension" extends "Item Charges"
{
    layout
    {
        addafter(Description)
        {
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
                Caption = 'Unit Price';
            }
        }
    }
}