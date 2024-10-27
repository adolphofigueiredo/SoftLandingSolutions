pageextension 50104 "Sales Order Page List Etension" extends "Sales Order List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(CreatedProdOrder; Rec.CreatedProdOrder)
            {
                Visible = true;
                ApplicationArea = all;
            }
        }
        modify("External Document No.")
        {
            Visible = false;
        }

        modify("Location Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")

        {
            Visible = false;
        }
    }
}