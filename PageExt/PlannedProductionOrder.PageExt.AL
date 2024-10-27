pageextension 50109 "Planned Production Order ext" extends "Planned Production Order"
{
    trigger OnOpenPage()
    var
        ProdOrdList: Page "Production Order List";
    begin
        ProdOrdList.CalcProdCycleLine();
    end;

    trigger OnClosePage()
    var
        ProdOrdList: Page "Production Order List";
    begin
        ProdOrdList.CalcProdCycleLine();
    end;
}