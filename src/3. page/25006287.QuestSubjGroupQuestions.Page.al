page 25006287 "Quest. Subj. Group Questions"
{
    Caption = 'Questionary Subject Group Questions';
    PageType = List;
    SourceTable = Table25006209;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Questionary Subject Group Code"; "Questionary Subject Group Code")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field("Question Text"; "Question Text")
                {
                }
                field("Answer Type"; "Answer Type")
                {
                }
                field("Default Value"; "Default Value")
                {
                }
                field("MIN Constrain"; "MIN Constrain")
                {
                }
                field("MAX Constrain"; "MAX Constrain")
                {
                }
            }
            part(; 25006288)
            {
                Editable = AllowModifyValues;
                SubPageLink = Questionary Subject Group Code=FIELD(Questionary Subject Group Code),
                              Question No.=FIELD(No.);
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        AllowModifyValues := "Answer Type" IN ["Answer Type"::Dictionary, "Answer Type"::Option];
    end;

    var
        [InDataSet]
        AllowModifyValues: Boolean;
}

