pageextension 50106 "Production Order List Ext" extends "Production Order List"
{
    layout
    {

        addafter("No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;

                //Lookup("Sales Order List" where ( "No."= field(Rec."Sales Order No.")));




            }
        }

        modify("Search Description")
        {
            Visible = false;
        }

        modify("Assigned User ID")
        {
            Visible = false;
        }



    }

    actions
    {

    }

    var
        myInt: Integer;
}