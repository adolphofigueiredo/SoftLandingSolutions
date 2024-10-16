pageextension 50104 "Sales Order Page List Etension" extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here

        modify("Location Code")

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
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}