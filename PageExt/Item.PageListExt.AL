pageextension 50103 "Item List Extension" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("Item Type"; Rec."Item Type")
            {
                Caption = 'Item Type';
                ApplicationArea = all;
            }


        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }

        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Routing No.")
        {
            Visible = false;
        }
        modify("Production BOM No.")
        {
            Visible = false;
        }

        modify("Assembly BOM")
        {
            Visible = false;
        }
        modify("Search Description")
        {
            Visible = false;
        }
    }
}