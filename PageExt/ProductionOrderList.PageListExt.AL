pageextension 50106 "Production Order List Ext" extends "Production Order List"
{
    layout
    {

        addafter("No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
                Editable = false;
                TableRelation = "Sales Header"."No." where("Document Type" = const(Order));




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