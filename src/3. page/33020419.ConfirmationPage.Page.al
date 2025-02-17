page 33020419 "Confirmation Page"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Education)
            {
                field(MFaculty; MFaculty)
                {
                    Caption = 'Master';
                }
                field(BFaculty; BFaculty)
                {
                    Caption = 'Bachelor';
                }
                field(IFaculty; IFaculty)
                {
                    Caption = 'Intermediate';
                }
            }
            group("Work Experience")
            {
                field(Experience; Experience)
                {
                }
            }
            group("Driving License")
            {
                field(License; License)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000010>")
            {
                Caption = 'Functions';
                action("Show ShortList")
                {
                    Caption = 'Show ShortList';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //msg('123');
                        ApplicationNew.RESET;
                        ApplicationNew.SETFILTER(M_Faculty, MFaculty);
                        ApplicationNew.SETFILTER(B_Faculty, BFaculty);
                        ApplicationNew.SETFILTER(I_Faculty, IFaculty);
                        IF Experience <> '' THEN
                            ApplicationNew.SETFILTER(WE1_Duration, Experience);

                        ApplicationNew.SETFILTER("Driving License", License);

                        //ShortListed.SetAllFilters(ApplicationNew);
                        ShortListed.SETTABLEVIEW(ApplicationNew);
                        ShortListed.RUNMODAL;
                    end;
                }
            }
        }
    }

    var
        ApplicationNew: Record "33020382";
        ShortListed: Page "33020418";
        MFaculty: Text[30];
        BFaculty: Text[30];
        IFaculty: Text[30];
        Experience: Text[30];
        License: Text[30];
        VacancyHeader: Record "33020380";
        VacancyLines: Record "33020381";
}

