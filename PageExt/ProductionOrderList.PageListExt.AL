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

            field("Prod. cycle line"; Rec."Prod. cycle line")
            {
                ApplicationArea = all;
            }
            field("Prod. cycle amount"; Rec."Prod. cycle amount")
            {
                ApplicationArea = all;

            }

            field("Prod. cycles number"; Rec."Prod. cycles number")
            {
                ApplicationArea = all;
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
    trigger OnOpenPage()
    var
        ProductionOrder: Record "Production Order";
    begin
        ProductionOrder.FindSet();
        repeat begin
            if ProductionOrder.Status = ProductionOrder.Status::Released then begin
                ProductionOrder.CalcFields(ProductionOrder."Prod. cycles number", ProductionOrder."Prod. cycle amount");
                ProductionOrder."Prod. cycle line" := Format(ProductionOrder."Prod. cycle amount") + ' / ' + Format(ProductionOrder."Prod. cycles number");
                ProductionOrder.Modify();
            end;
        end until ProductionOrder.Next() = 0;
    end;

    var
        myInt: Integer;
}