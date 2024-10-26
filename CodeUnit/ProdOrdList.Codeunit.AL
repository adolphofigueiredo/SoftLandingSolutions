codeunit 50101 gg
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnAfterInsertConsumptionJnlLine', '', false, false)]
    local procedure OnAfterInsertConsumptionJnlLine(var ItemJournalLine: Record "Item Journal Line")
    var

    begin
        ToTemplateName := ItemJournalLine."Journal Template Name";
        ToBatchName := ItemJournalLine."Journal Batch Name";
    end;

    internal procedure GetTamplateName(): Code[10]
    begin
        exit(ToTemplateName);
    end;

    internal procedure GetBatchName(): Code[10]
    begin
        exit(ToBatchName);
    end;

    var
        ToTemplateName: code[10];
        ToBatchName: code[10];
}