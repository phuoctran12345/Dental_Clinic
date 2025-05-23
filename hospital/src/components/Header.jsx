import React from 'react';
import { Layout, Input, Button } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import styled from 'styled-components';

const { Header: AntHeader } = Layout;

const StyledHeader = styled(AntHeader)`
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
`;

const SearchContainer = styled.div`
  display: flex;
  align-items: center;
  width: 400px;
`;

const StyledInput = styled(Input)`
  border-radius: 20px;
  margin-right: 8px;
`;

const Header = () => {
  const handleSearch = (value) => {
    console.log('Searching for:', value);
    // Thêm logic tìm kiếm ở đây
  };

  return (
    <StyledHeader>
      <div className="logo">
        <h1>Hospital Management</h1>
      </div>
      <SearchContainer>
        <StyledInput
          placeholder="Tìm kiếm..."
          prefix={<SearchOutlined />}
          onPressEnter={(e) => handleSearch(e.target.value)}
        />
        <Button type="primary" shape="circle" icon={<SearchOutlined />} />
      </SearchContainer>
    </StyledHeader>
  );
};

export default Header; 