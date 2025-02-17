page 33020317 "Leave Type"
{
    PageType = List;
    SourceTable = Table33020345;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Type Code"; "Leave Type Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Days Earned Per Year"; "Days Earned Per Year")
                {
                }
                field("Maximum Allowable Limit"; "Maximum Allowable Limit")
                {
                }
                field("Maximum Earnable Limit"; "Maximum Earnable Limit")
                {
                }
                field(Encashable; Encashable)
                {
                }
                field("Pay Type"; "Pay Type")
                {
                }
                field("Earned Per Month"; "Earned Per Month")
                {
                }
                field("Earnable Per Year"; "Earnable Per Year")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Encash Leave")
            {

                trigger OnAction()
                var
                    LeaveAccount: Record "33020370";
                    CollapseLeaveTypeatYearEnd: Report "33020307";
                begin
                    LeaveAccount.RESET;
                    LeaveAccount.SETFILTER("Leave Type", 'HL|SC');
                    IF LeaveAccount.FINDFIRST THEN
                        REPEAT
                            IF (LeaveAccount."Total Writeoff Days (New)" > 90) AND (LeaveAccount."Leave Type" = 'HL') THEN BEGIN
                                CollapseLeaveTypeatYearEnd.EncashLeave(LeaveAccount."Employee Code", 1, LeaveAccount."Leave Type", LeaveAccount."Total Writeoff Days (New)" - 90, '2078/2079');
                                LeaveAccount."Total Writeoff Days (New)" := 90;
                            END;
                            IF (LeaveAccount."Total Writeoff Days (New)" > 45) AND (LeaveAccount."Leave Type" = 'SC') THEN BEGIN
                                CollapseLeaveTypeatYearEnd.EncashLeave(LeaveAccount."Employee Code", 1, LeaveAccount."Leave Type", LeaveAccount."Total Writeoff Days (New)" - 45, '2078/2079');
                                LeaveAccount."Total Writeoff Days (New)" := 45;
                            END;

                            LeaveAccount.MODIFY;
                        UNTIL LeaveAccount.NEXT = 0;

                    MESSAGE('complete');
                end;
            }
        }
    }
}

