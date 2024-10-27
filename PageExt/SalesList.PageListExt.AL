pageextension 50107 "Sales List Page Extension" extends "Sales List"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }

    }
}