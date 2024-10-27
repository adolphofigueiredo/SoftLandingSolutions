tableextension 50100 "Sales Line Extension" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                itemRecord: Record Item;
            begin
                if itemRecord.Get("No.") then begin
                    "Item Type" := itemRecord."Item Type";
                end;
            end;
        }
        field(50100; "Item Type"; Enum "Article Type")
        {
            Caption = 'Item Type';
            Editable = false;
            
        }
    }
}