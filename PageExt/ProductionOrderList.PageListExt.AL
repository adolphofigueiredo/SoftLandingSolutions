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
            field("Prod. cycle status"; Rec."Prod. cycle status")
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
        addafter("Pro&d. Order")
        {
            action(RefreshProdOrdStatuts)
            {
                Caption = 'Riaggiorna stato ordini produzione';
                Image = Refresh;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category5;
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
        ProdOrdList: Codeunit ProdOrdList;
        Progress: Dialog;
        Counter: Integer;
        ProgressMsg: Label 'Processing......#1######################\';
    begin
        Counter := 0;
        Progress.OPEN(ProgressMsg, Counter);
        Progress.UPDATE(1, Counter);
        ProdOrder.SetRange(Status, ProdOrder.Status::Released, ProdOrder.Status::Finished);
        ProdOrder.FindSet();
        repeat begin
            if ProdOrder.Status = ProdOrder.Status::Released then begin
                Clear(ProductionJrnlMgt);
                ProductionJrnlMgt.SetTemplateAndBatchName();
                ProductionJrnlMgt.InitSetupValues();
                ProductionJrnlMgt.DeleteJnlLines(ProdOrdList.GetTamplateName(), ProdOrdList.GetBatchName(), ProdOrder."No.", 10000);
                ProductionJrnlMgt.CreateJnlLines(ProdOrder, 10000);
                ProdOrder.CalcFields(ProdOrder."Prod. cycles number");
                ProdOrder."Prod. cycle status" := Format(CalcolaStato(ProdOrder)) + ' / ' + Format(ProdOrder."Prod. cycles number");
                ProdOrder.Modify();
                Counter := Counter + 1;
                Progress.UPDATE(1, Counter);
                SLEEP(10);
            end;
            if ProdOrder.Status = ProdOrder.Status::Finished then begin
                ProdOrder.CalcFields(ProdOrder."Prod. cycles number");
                ProdOrder."Prod. cycle status" := Format(ProdOrder."Prod. cycles number") + ' / ' + Format(ProdOrder."Prod. cycles number");
                ProdOrder.Modify();
            end;
        end until ProdOrder.Next() = 0;
        Progress.CLOSE();
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