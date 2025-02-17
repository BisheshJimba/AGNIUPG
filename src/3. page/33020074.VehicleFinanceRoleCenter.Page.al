page 33020074 "Vehicle Finance Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 33020073)
                {
                }
                part(; 33020134)
                {
                }
                chartpart("5000-1"; "5000-1")
                {
                }
                chartpart("5000-1"; "5000-1")
                {
                }
            }
            group()
            {
                systempart(; Outlook)
                {
                }
                part(; 9150)
                {
                }
                systempart(; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                Caption = '&G/L Trial Balance';
                RunObject = Report 6;
            }
            action("&Bank Detail Trial Balance")
            {
                Caption = '&Bank Detail Trial Balance';
                RunObject = Report 1404;
            }
            separator(VFD)
            {
                Caption = 'VFD';
            }
            action("<Action1000000001>")
            {
                Caption = 'Collection Report';
                RunObject = Report 33020172;
            }
            action("<Action1000000002>")
            {
                Caption = 'Cash Receipt by Batch';
                RunObject = Report 33020171;
            }
        }
        area(embedding)
        {
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                RunObject = Page 371;
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page 22;
            }
            action("Sales Invoices")
            {
                Caption = 'Sales Invoices';
                RunObject = Page 33020251;
            }
            action("Application Files")
            {
                RunObject = Page 33020064;
            }
            action("Loan Files")
            {
                RunObject = Page 33020068;
            }
            action("Insurance Expired")
            {
                RunObject = Page 33020290;
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page 143;
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page 144;
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    RunObject = Page 116;
                }
            }
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("Sales &Credit Memo")
            {
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 44;
                RunPageMode = Create;
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cas&h Receipt Journal")
            {
                Caption = 'Cas&h Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page 255;
            }
            action("Pa&yment Journal")
            {
                Caption = 'Pa&yment Journal';
                Image = PaymentJournal;
                RunObject = Page 256;
            }
            separator()
            {
            }
            action("Bank Account R&econciliation")
            {
                Caption = 'Bank Account R&econciliation';
                RunObject = Page 379;
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page 344;
            }
        }
    }
}

