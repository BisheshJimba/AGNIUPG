page 25006559 "Aftersales CRM Role Center"
{
    Caption = 'Aftersales CRM Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 25006558)
                {
                }
                part("My Contacts"; 25006556)
                {
                }
                systempart(; Outlook)
                {
                }
            }
            group()
            {
                part("Sales Campaign Performance"; 25006557)
                {
                    Caption = 'Sales Campaign Performance';
                }
                systempart(; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Campaigns)
            {
                Caption = 'Campaigns';
                RunObject = Page 5087;
            }
            action("To-Dos")
            {
                Caption = 'To-Dos';
                RunObject = Page 5096;
            }
            action(Segments)
            {
                Caption = 'Segments';
                RunObject = Page 5093;
            }
            action(Contracts)
            {
                Caption = 'Contracts';
                RunObject = Page 25006046;
            }
            action(CustomersList)
            {
                Caption = 'Customers';
                RunObject = Page 22;
            }
            action(ContactsList)
            {
                Caption = 'Contacts';
                RunObject = Page 5052;
            }
        }
        area(processing)
        {
            group(Tasks)
            {
                action("New Contact")
                {
                    Caption = 'New Contact';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page 5050;
                    RunPageMode = Create;
                }
                action("New Campaign")
                {
                    Caption = 'New Campaign';
                    Image = Campaign;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page 5086;
                    RunPageMode = Create;
                }
                action("New Opportunity")
                {
                    Caption = 'New Opportunity';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page 5124;
                    RunPageMode = Create;
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                action("Campaign Details")
                {
                    Caption = 'Campaign Details';
                    Image = CampaignEntries;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 5060;
                }
                action("Top 10 Customers")
                {
                    Caption = 'Top 10 Customers';
                    Image = CustomerRating;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report 111;
                }
            }
            group(Worksheets)
            {
                action("Interaction Log Entries")
                {
                    Caption = 'Interaction Log Entries';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 5076;
                }
                action("To-Do")
                {
                    Caption = 'To-Do';
                    Image = TaskPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 5096;
                }
            }
        }
        area(sections)
        {
            group(Catalogues)
            {
                Caption = 'Catalogues';
                action(Makes)
                {
                    Caption = 'Makes';
                    RunObject = Page 25006014;
                }
                action(Models)
                {
                    Caption = 'Models';
                    RunObject = Page 25006016;
                }
                action(Vehicles)
                {
                    Caption = 'Vehicles';
                    RunObject = Page 25006033;
                }
                action(Customers)
                {
                    Caption = 'Customers';
                    RunObject = Page 22;
                }
                action(Vendors)
                {
                    Caption = 'Vendors';
                    RunObject = Page 27;
                }
                action(Contacts)
                {
                    Caption = 'Contacts';
                    RunObject = Page 5052;
                }
                action(Items)
                {
                    Caption = 'Items';
                    RunObject = Page 31;
                }
                action(Labors)
                {
                    Caption = 'Labors';
                    RunObject = Page 25006152;
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Campaign Entries")
                {
                    Caption = 'Campaign Entries';
                    RunObject = Page 5089;
                }
                action("Oportunity Entries")
                {
                    Caption = 'Oportunity Entries';
                    RunObject = Page 5130;
                }
            }
        }
    }
}

