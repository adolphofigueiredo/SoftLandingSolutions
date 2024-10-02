page 50150 "SLS Commesse Base Header Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Commesse Base Header Page';
    SourceTable = "SLS Commesse Base Header";

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