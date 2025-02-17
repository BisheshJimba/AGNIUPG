page 33019815 "NCHL-NPI Bank-Branch Lists"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019814;
    SourceTableView = SORTING(Agent, Line No.);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Agent; Agent)
                {
                    Caption = 'Bank ID';
                    Visible = NOT IsVisible;
                }
                field(Name; Name)
                {
                    Visible = NOT IsVisible;
                }
                field(Branch; Branch)
                {
                    Visible = NOT IsVisible;
                }
                field(Scheme; "Document No.")
                {
                    Visible = IsVisible;
                }
                field(Currency; "Batch Currency")
                {
                    Visible = IsVisible;
                }
                field("Max Amount"; "Transaction Charge Amount")
                {
                    Visible = IsVisible;
                }
                field("Max Charge Amount"; "Debit Amount")
                {
                    Visible = IsVisible;
                }
                field("Min Charge Amount"; "Credit Amount")
                {
                    Visible = IsVisible;
                }
                field(Percent; "Category Purpose")
                {
                    Visible = IsVisible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group()
            {
                action(GetBranchLists)
                {
                    Caption = 'Get Branch Lists';
                    Image = GetActionMessages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        CIPSWebServiceMgt: Codeunit "33019811";
                        CIPSBankList: Page "33019815";
                        TempCIPSBankAccount: Record "33019814";
                    begin
                        TempCIPSBankAccount.RESET;
                        TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                        IF TempCIPSBankAccount.FINDFIRST THEN
                            TempCIPSBankAccount.DELETEALL;

                        CIPSWebServiceMgt.GetCIPSBankBranchList(Agent);
                        CLEAR(CIPSBankList);
                        TempCIPSBankAccount.RESET;
                        TempCIPSBankAccount.SETCURRENTKEY(Agent, Branch, "Line No.");
                        TempCIPSBankAccount.SETASCENDING(Branch, TRUE);
                        TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                        CIPSBankList.SETRECORD(TempCIPSBankAccount);
                        CIPSBankList.SETTABLEVIEW(TempCIPSBankAccount);
                        CIPSBankList.LOOKUPMODE(TRUE);
                        CIPSBankList.RUN;
                    end;
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        TempCIPSBankAccount.RESET;
        TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
        IF TempCIPSBankAccount.FINDFIRST THEN
            TempCIPSBankAccount.DELETEALL;
    end;

    var
        TempCIPSBankAccount: Record "33019814";
        IsVisible: Boolean;

    [Scope('Internal')]
    procedure SetVisible(NewIsVisible: Boolean)
    begin
        IsVisible := NewIsVisible;
    end;
}

