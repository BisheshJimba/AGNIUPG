page 33020201 "Salesperson KAP Activities"
{
    Caption = 'KAP Activities';
    PageType = List;
    SourceTable = Table33020159;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field(Year; Year)
                {
                }
                field(Month; Month)
                {
                }
                field("Week No"; "Week No")
                {
                }
                field("No. of Activities Planned"; "No. of Activities Planned")
                {

                    trigger OnAssistEdit()
                    begin
                        //gblCRMMngt.ShowKAPDetails("Salesperson Code",Year,Month,"Week No");
                    end;
                }
                field("No. of Activities Completed"; "No. of Activities Completed")
                {

                    trigger OnAssistEdit()
                    begin
                        //gblCRMMngt.ShowKAPDetails("Salesperson Code",Year,Month,"Week No");
                    end;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(OpenPictureBox)
            {
                Caption = '&Load Picture(s)';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020204;
                RunPageLink = Sales Person Code=FIELD(Salesperson Code),
                              Year=FIELD(Year),
                              Month=FIELD(Month),
                              Week No.=FIELD(Week No);
            }
            action("<Action1000000000>")
            {
                Caption = '&KAP Details';
                Image = EditList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020206;
                                RunPageLink = Salesperson Code=FIELD(Salesperson Code),
                              Year=FIELD(Year),
                              Month=FIELD(Month),
                              Week No=FIELD(Week No);
            }
        }
    }

    var
        gblCRMMngt: Codeunit "33020142";
        gblKAPActDetails: Record "33020200";
        gblKAPActDetails2: Record "33020200";
        gblNoOfPlanned: Integer;
        gblNoOfCompleted: Integer;
}

