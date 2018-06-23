import React, { Component } from 'react';
import { Card, Button } from 'semantic-ui-react';
import factory from '../ethereum/factory';
import Layout from '../components/Layout';
import { Link } from '../routes';

class LoanIndex extends Component {
  static async getInitialProps() {
    const loans = await factory.methods.getDeployedLoans().call();

    return { loans };
  }

  renderLoans() {
    const items = this.props.loans.map(address => {
      return {
        header: address,
        description: (
          <Link route={`/campaigns/${address}`}>
            <a>View Loan</a>
          </Link>
        ),
        fluid: true
      };
    });

    return <Card.Group items={items} />;
  }

  render() {
    return (
      <Layout>
        <div>
          <h3>Open Loan</h3>

          <Link route="/campaigns/new">
            <a>
              <Button
                floated="right"
                content="Create Loan"
                icon="add circle"
                primary
              />
            </a>
          </Link>

          {this.renderLoans()}
        </div>
      </Layout>
    );
  }
}

export default LoanIndex;