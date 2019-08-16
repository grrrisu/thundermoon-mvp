describe('root page', function() {
  it('should see the title', function() {
    cy.visit("http://localhost:4000");
    cy.contains('Thundermoon');
  })
});

describe('dashboard page', function() {
  it('should see the title', function() {
    cy.visit("http://localhost:4000/dashboard");
    cy.contains('Welcome grrrisu');
  })
});