const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const getAllCourses = async (req, res) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    const whereClause = {
      published: true,
      OR: [
        { title: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } }
      ]
    };

    const [courses, total] = await Promise.all([
      prisma.course.findMany({
        where: whereClause,
        include: {
          instructor: {
            select: {
              id: true,
              name: true,
              email: true
            }
          },
          reviews: {
            select: {
              rating: true,
              comment: true
            }
          }
        },
        skip,
        take: parseInt(limit),
        orderBy: { createdAt: 'desc' }
      }),
      prisma.course.count({ where: whereClause })
    ]);

    res.json({
      success: true,
      data: courses,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });
  } catch (error) {
    console.error('Get courses error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch courses'
    });
  }
};

const getCourseById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const course = await prisma.course.findUnique({
      where: { id: parseInt(id) },
      include: {
        instructor: {
          select: {
            id: true,
            name: true,
            email: true,
            bio: true
          }
        },
        reviews: {
          include: {
            user: {
              select: {
                id: true,
                name: true
              }
            }
          }
        },
        lessons: {
          orderBy: { order: 'asc' },
          where: { published: true }
        }
      }
    });

    if (!course) {
      return res.status(404).json({
        success: false,
        error: 'Course not found'
      });
    }

    res.json({
      success: true,
      data: course
    });
  } catch (error) {
    console.error('Get course error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch course'
    });
  }
};

module.exports = {
  getAllCourses,
  getCourseById
};