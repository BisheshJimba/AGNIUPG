page 33020239 "Service Gate Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group()
            {
                part(; 33020240)
                {
                }
            }
            group()
            {
                part(; 9150)
                {
                }
                part(; 9152)
                {
                    Visible = false;
                }
                part(; 9175)
                {
                    Visible = false;
                }
                systempart(; MyNotes)
                {
                }
                chartpart("25006100-01"; "25006100-01")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Report 1")
            {
                Caption = 'Report 1';
            }
        }
        area(embedding)
        {
            action("Service Quotes")
            {
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page 25006254;
            }
            action("Service Orders")
            {
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page 25006185;
            }
            action("<Action1101904016>")
            {
                Caption = 'Sales Invoices';
                RunObject = Page 25006175;
            }
            action("<Action15>")
            {
                Caption = 'Service Return Orders';
                Image = Document;
                RunObject = Page 25006255;
            }
            action("Sales Cr.Memos")
            {
                Caption = 'Sales Cr.Memos';
                RunObject = Page 25006176;
            }
            action("<Action55>")
            {
                Caption = 'Contacts';
                RunObject = Page 5052;
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page 22;
            }
            action("<Action57>")
            {
                Caption = 'Vehicles';
                RunObject = Page 25006033;
            }
            action("<Action1101904005>")
            {
                Caption = 'Transfer Orders';
                RunObject = Page 25006217;
            }
            action("Item Journals")
            {
                Caption = 'Item Journals';
                RunObject = Page 262;
                RunPageView = WHERE(Template Type=CONST(Item),
                                    Recurring=CONST(No));
            }
            action("Requisition Worksheets")
            {
                Caption = 'Requisition Worksheets';
                RunObject = Page 295;
                RunPageView = WHERE(Template Type=CONST(Req.),
                                    Recurring=CONST(No));
            }
        }
        area(sections)
        {
            group("<Action1101904009>")
            {
                Caption = 'Catalogues';
                Image = ReferenceData;
                action("<Action1101904014>")
                {
                    Caption = 'Makes';
                    RunObject = Page 25006014;
                }
                action(Models)
                {
                    Caption = 'Models';
                    RunObject = Page 25006016;
                }
                action("<Action58>")
                {
                    Caption = 'Items';
                    RunObject = Page 31;
                }
                action("<Action1101904010>")
                {
                    Caption = 'Nonstock Items';
                    RunObject = Page 5726;
                }
                action("<Action1101904002>")
                {
                    Caption = 'Labors';
                    RunObject = Page 25006152;
                }
                action("<Action1101904003>")
                {
                    Caption = 'External Services';
                    RunObject = Page 25006174;
                }
                action("<Action1101904004>")
                {
                    Caption = 'Service Packages';
                    RunObject = Page 25006161;
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Action60>")
                {
                    Caption = 'Posted Service Orders';
                    RunObject = Page 25006197;
                }
                action("<Action61>")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page 25006189;
                }
                action("<Action60 >")
                {
                    Caption = 'Posted Service Return Orders';
                    RunObject = Page 25006220;
                }
                action("<Action62>")
                {
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page 25006190;
                }
                action("<Action137>")
                {
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page 25006191;
                }
                action("<Action3>")
                {
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page 25006192;
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
            action("<Action1101904019>")
            {
                Caption = 'Schedule';
                RunObject = Page 25006358;
            }
            action("Service Q&uote")
            {
                Caption = 'Service Q&uote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 25006198;
                RunPageMode = Create;
            }
            action("Service &Order")
            {
                Caption = 'Service &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 25006183;
                RunPageMode = Create;
            }
            action("<Action18>")
            {
                Caption = 'Transfer &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page 5740;
                RunPageMode = Create;
                RunPageView = SORTING(Document Profile)
                              WHERE(Document Profile=CONST(Service));
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("<Action29>")
            {
                Caption = 'Schedule';
                RunObject = Page 25006358;
            }
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("<Action33>")
            {
                Caption = 'Service Packages';
                RunObject = Page 25006161;
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

