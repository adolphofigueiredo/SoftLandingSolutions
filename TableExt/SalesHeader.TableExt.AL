tableextension 50104 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100;"CreatedProdOrder";boolean)
        {
            Caption = 'Ordine di produzione creato';
            Editable = false;
            InitValue = false;
            FieldClass = FlowField;
            CalcFormula = exist("Production Order" where("Sales Order No." = field("No.")));
        }
    }

}