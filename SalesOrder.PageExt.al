pageextension 50152 "SLS Sales Order Extension" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Processing)
        {

            group("Pacchetti Base")
            {
                Image = Sales;
                action("Finestra Standard in PVC")
                {
                    ApplicationArea = All;
                    Caption = 'Finestra Standard in PVC';
                    Image = Order;

                    trigger OnAction()
                    begin
                        Message('Finestra Standard in PVC');
                    end;
                }

                action("Pacchetto Base 02")
                {
                    ApplicationArea = All;
                    Caption = 'Finestra Standard in Alluminio';
                    Image = Order;
                    trigger OnAction()
                    begin
                        Message('Finestra Standard in Alluminio');
                    end;
                }
            }
        }
    }
}