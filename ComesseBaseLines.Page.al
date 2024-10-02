page 50151 "SLS Commesse Base Lines Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Commesse Base Lines Page';
    SourceTable = "SLS Commesse Base Lines";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No Pacchetto Base"; Rec."No. Pacchetto Base")
                {
                    ApplicationArea = All;

                }

                field("Pachetto Base"; Rec."Pacchetto Base")
                {
                    ApplicationArea = All;

                }

                field("No Componente"; Rec."No. Componente")
                {
                    ApplicationArea = All;

                }

                field(Componente; Rec.Componente)
                {
                    ApplicationArea = All;

                }

                field("Quantità Componente"; Rec."Quantità Componente")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}