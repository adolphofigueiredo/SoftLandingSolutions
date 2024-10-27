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
            field("Prod. cycles number"; Rec."Prod. cycles number")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Prod. cycle status";Rec."Prod. cycle status")
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
        addafter("E&ntries")
        {
            action(ActionName)
            {
                Caption = '';
                ApplicationArea = all;
                Visible = true;
                trigger OnAction()
                begin
                    CalcProdCycleLine();
                    CurrPage.Update();
                end;
            }
        }
    }
    internal procedure CalcProdCycleLine()
    var
        ProdOrder: Record "Production Order";
        ProductionJrnlMgt: Codeunit "Production Journal Mgt";
        gg: Codeunit gg;
    begin
        ProdOrder.FindSet();
        repeat begin
            if ProdOrder.Status = ProdOrder.Status::Released then begin
                Clear(ProductionJrnlMgt);
                ProductionJrnlMgt.SetTemplateAndBatchName();
                ProductionJrnlMgt.InitSetupValues();
                ProductionJrnlMgt.DeleteJnlLines(gg.GetTamplateName(), gg.GetBatchName(), ProdOrder."No.", 10000);
                ProductionJrnlMgt.CreateJnlLines(ProdOrder, 10000);
                ProdOrder.CalcFields(ProdOrder."Prod. cycles number");
                ProdOrder."Prod. cycle status" := Format(CalcolaStato(ProdOrder)) + ' / ' + Format(ProdOrder."Prod. cycles number");
                ProdOrder.Modify();
            end;
        end until ProdOrder.Next() = 0;

    end;
    internal procedure CalcolaStato(var ProdOrder: Record "Production Order"): Integer
    var
        i: Integer;
        ItemJournalLine: Record "Item Journal Line";
    begin
        i := 0;
        ItemJournalLine.SetRange("Document No.", ProdOrder."No.");
        ItemJournalLine.SetRange("Gen. Prod. Posting Group", 'MANUFACT');
        ItemJournalLine.SetRange(Quantity, 0);
        if ItemJournalLine.FindSet() then begin
            repeat begin
                i += 1;
            end until ItemJournalLine.Next() = 0;
        end;
        exit(i)
    end;
}