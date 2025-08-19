
import React from 'react';
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box
} from '@mui/material';

interface Course {
  id: number;
  title: string;
  description: string;
  price: number;
  instructor: {
    name: string;
  };
  reviews: {
    rating: number;
  }[];
}

interface CourseCardProps {
  course: Course;
  onEnroll: (courseId: number) => void;
  isLoading?: boolean;
}

const CourseCard: React.FC<CourseCardProps> = ({ 
  course, 
  onEnroll, 
  isLoading = false 
}) => {
  const handleEnroll = () => {
    if (!isLoading) {
      onEnroll(course.id);
    }
  };

  return (
    <Card sx={{ maxWidth: 345, m: 2, opacity: isLoading ? 0.7 : 1 }}>
      <CardContent>
        <Typography gutterBottom variant="h5" component="h2">
          {course.title}
        </Typography>
        <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
          {course.description}
        </Typography>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Typography variant="body2">
            المدرب: {course.instructor.name}
          </Typography>
          <Typography variant="h6" color="primary">
            {course.price} ر.س
          </Typography>
        </Box>
      </CardContent>
      <CardActions>
        <Button 
          size="small" 
          variant="contained" 
          onClick={handleEnroll}
          disabled={isLoading}
          fullWidth
        >
          {isLoading ? 'جاري التسجيل...' : 'سجل الآن'}
        </Button>
      </CardActions>
    </Card>
  );
};

export default CourseCard;