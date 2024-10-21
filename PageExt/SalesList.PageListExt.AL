pageextension 50107 "Sales List Page Extension" extends "Sales List"
{
    layout
    {
        modify("Location Code")
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