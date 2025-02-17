page 25006177 "Skill Codes EDMS"
{
    Caption = 'Skill Codes';
    PageType = List;
    SourceTable = Table25006159;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Skills)
            {
                Caption = 'Skills';
                action("Resource Skills")
                {
                    Caption = 'Resource Skills';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ResourceSkills: Record "25006160";
                    begin
                        ResourceSkills.RESET;
                        ResourceSkills.SETRANGE("Skill Code", Code);

                        PAGE.RUNMODAL(PAGE::"Resource Skills EDMS", ResourceSkills);
                    end;
                }
                action("Labor Skills")
                {
                    Caption = 'Labor Skills';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LaborSkills: Record "25006161";
                    begin
                        LaborSkills.RESET;
                        LaborSkills.SETRANGE("Skill Code", Code);

                        PAGE.RUNMODAL(PAGE::"Service Labor Skills", LaborSkills);
                    end;
                }
            }
        }
    }
}

