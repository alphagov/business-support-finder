jQuery(function($) {
  GOVUK.filterListItems.init();

  if ($('#beta-business-support-link').length > 0) {
    GOVUK.analytics.addLinkedTrackerDomain('UA-53250464-6', 'beta_bsf', 'service.gov.uk');
  }
});
