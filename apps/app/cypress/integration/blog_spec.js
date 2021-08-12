describe('Blog Page', () => {
  it('shows posts', () => {
    cy.setupDB("app", "blog")

    cy.visit('/blog')

    cy.get('article').should('exist')
  })
})
